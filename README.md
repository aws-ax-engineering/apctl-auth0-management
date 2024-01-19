# apctl-auth0-management

Internal engineering platform command line tool idp integration.  

Configuration of Auth0 applications, social integrations, and actions to support the aws-engineering-poc command line tool (`apctl`).

As a POC, we naturally did not have programmatic access to standard amex IDP services. For the actual implementation you can make use of any authorized idp that provides oauth2/oidc device authorization flows. Caveat: another time saving benefit of using Auth0.com in the poc is that few of the competing services in the market place provide full features authorization server hooks. By that we mean, using Auth0 we are able to both, defer to the github SSO (github auth however configured) and also upon successful authN, fetch cliams and generate a verifiable JWT without neending to deploy and manage a separate service to perform that actions. Using a different service (such as Okta) this will need to be addressed.  

The oauth0/oidc flow required by the apctl tool is available in the free tier of Auth0. Complete these [bootstrap](doc/bootstrap.md) steps as part of signing up for Auth0 and preparing for the pipeline managed Auth0 configuration.  

With a management api token now available, this pipeline will perform the following tasks:

* Create a Social authn integration with the github oauth client previously defined.  
*  
* Create an auth0.com application client to be used by the apctl tool.

* Create a custom action that will run after a successful github social-authentication. The action fetches the Users teams for the integrated (above) github organization.

* 'Deploy' the trigger integration so that the action runs immediately after authentication.

* Create the GitHub authentication integration and associate with the apctl client application.

The above results in the creation of an oauth2/oidc device-auth-flow endpoint that will be used by the apctl command line tool.

This endpoint implements the oauth2/oidc device-auth-flow. Using the apctl cli, when you perform a `login` command, you will be provided a link. From your browser, proceed to the link and enter the provided device code. You must then authenticate to Github. This is performed via Githubs oauth service and no credential information is made available to Auth0.

In addition to this social-login connection, upon a successful github login, the auth0 application client will fetch the list of github teams the user is a member of the github organization. This list is included as a claim within the resulting id token.

### development

The above github oauth app and auth0 management api tokens must be available in th environment for the python scripts to work.  

- token expires after 1hr (3600)
- can be refreshed (refresh token provided)
- absolute lifetime for refresh for token in active use is 7 days (604800)
- an idle token cannot be refreshed after 2days (172800)

After completing the bootstrap steps, the github social connection in place and the Management API client endpoint available, now this repo pipeline can manage the Applications and Rules that define the functionality of our oidc endpoint.

The pipeline has three essential steps:

1. Fetch a management api token to use for creating and updating Auth0 configuration
2. Deploy the dev tenant apctl application definitions (would have both dev and prod in full implementation)
3. Deploy auth0 actions used by the apctl application login process

Since Auth0 is not used to perform any authentication functions, the actions are the steps to take in constructing a jwt to return from a successful authentication based solely on information provided by github.

In this case that means, if the user is a member of the github org where the github oauth-app is defined (in this case aws-engineering-poc) then they will be able to successfully authenticate, after which:

* with the resulting successful authN github access token, fetch all org teams of which the user is a member
* insert those teams as a list into the returned idToken

See repo pipeline for specific details.

