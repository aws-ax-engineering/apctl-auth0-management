## bootstrap steps for setting up Auth0.com for use with apctl

### Auth0 tenant configuration

Auth0 plays an important role in enabling the PSK platform cli to use github and github team membership for authentication and authorization with the engineering platform. While a critical component, it is also a fairly narrow slice of the overall flow.  

In this use case, the idp plays a limited, pass-through function. When a developer (customer) of the Platform uses the cli to `login`, auth0 coordinates the pass-through to Github for authentication, and it fetches the users 'claims' in the form of their team memberships within the Github organization. These are inserted into the returned id-token, but that is it. Each individual use of the resulting token involves completely seperate authorization automation depending on the target of the request.  

Because of this, the amount of configuration and the resulting testing needed is also quite limited. And, since the authenication workflow reuqires human interaction by design, while the configuration of the idp is automated there is a limited amount of automated testing that can used to validate the resulting idp Client. Mostly, when changes to the configuration are needed, the changes are pushed to the dev-tenant and then human interactive testing is used to validate the results.  

###  Create Oauth App in GitHub Organization

Create dev-apctl oauth app  

_note: assuming you have github machine-accounts, you can do this step at part of the apctl-auth0-management pipeline. For the pos, we did this manually just to save some time._  

1. In the GitHub **Organization** settings, open `Oauth Apps` under `Developer Settings`

2. Click the `New Org OAuth App` button in the upper right.  

3. Enter the necessary info the for the dev-apctl auth0 tenant. (ap=amex platform)  

_https://dev-apctl.us.auth0.com_  
_https://dev-apctl.us.auth0.com/login/callback_  

> Note: You do not need to check Enable Device Flow here as this will be managed by Auth0

On the screen that follows, create a new `Client Secret`. Save both the Client ID and the Client Secret in your secrets store.  

### Bootstrap Management API client in Auth0

1. Login using github authentication - free tier is all that is needed
   
2. Create a development tenants:

* dev-apctl  

3. Swtich to the dev-apctl tenant. Go to the applications dashboard and click `Create Application`.  

Set the name for the new application to `Management API` and choose Machine-to-Machine-Application and the app type.  

On the screen that follows, select the 'Auth0 Managment API' option from the popup.  

Next, Under Permissions click `Select: All` and click `Authorize`  

From the example window, copy the client_id and client_secret and store these in your secrets store.


_The related auth.com documentation_:  
- [machine-to-machine apps](https://auth0.com/docs/get-started/auth0-overview/create-applications/machine-to-machine-apps)
- [Managegment API Tokens](https://auth0.com/docs/secure/tokens/access-tokens/get-management-api-access-tokens-for-production)
