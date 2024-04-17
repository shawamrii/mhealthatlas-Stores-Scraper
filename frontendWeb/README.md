# Demo Webfrontend

The *Demo Webfrontend* provides functionalities for visualizing and testing the backend functionalities. The host name and the port of the web server can be configured with the environment variables `WEB_FRONTEND_NAME` and `WEB_FRONTEND_PORT`, whereby the default values are `mhealthatlas` and `5556`.

## Dependencies

This service depends on the gateway (`mhealthatlas-gateway`) and the identity provider (`keycloak-mhealthatlas`). The service is only functional, if all of these service are running.

## *Demo Webfronend* Folder Structure

The table below gives an overview of the subfolder structure of the *frontendWeb* folder.

| Folder | Short Description |
| ----   |     ----          |
| [auth](src/app/auth/) | contains all functionalities to interact with identity provider |
| [data](src/app/data/) | contains all functionalities to interact with the backend API endpoints |
| [dto](src/app/dto/) | contains all data transfer objects |
| [enterprise-apps](src/app/enterprise-apps/) | contains a GUI for interacting with the *Enterprise* service |
| [enterprise-management](src/app/enterprise-management/) | contains a GUI for interacting with the *Enterprise Management* service |
| [header](src/app/header) | contains the visualization of the navigation bar |
| [helpers](src/app/helpers) | contains utility methods |
| [manage-mhealthatlas-app](src/app/manage-mhealthatlas-app/) | contains a GUI for interacting with the command API endpoints of the *Application* service |
| [mhealthatlas-app-detail](src/app/mhealthatlas-app-detail/) | contains a GUI for interacting with the query application version API endpoints of the *Application* service |
| [mhealthatlas-apps](src/app/mhealthatlas-apps/) | contains a GUI for interacting with the query application API endpoints of the *Application* service |
| [mhealthatlas-users](src/app/mhealthatlas-users/) | contains a GUI for interacting with the *mHealthAtlas User* service |
| [models](src/app/models) | contains all data models of the service |
| [questionnaire](src/app/questionnaire/) | contains a GUI for interacting with the questionnaire API endpoints of the *Rating* service |
| [rating](src/app/rating/) | contains a GUI for interacting with the rating API endpoints of the *Rating* service |
| [taxonomy](src/app/taxonomy/) | contains a GUI for interacting with the *Taxonomy* service |
| [user](src/app/user/) | contains a GUI for interacting with the *User Management* service |
| [userinfo](src/app/userinfo) | contains all functionalities to update the displayed user informations based on the access token |
| [app](src/app/) | contains the rooting and root modules |
| [environments](src/environments) | contains the configuration |

## Configuration Parameters

The table below lists the configuration parameters for the service and describes shortly what each parameter does. Additionally, the configured value is show. Either the listed parameters values are defined directly in the [environment.\<mode\>.ts](src/environment.prod.ts) files.

| Configuration Parameter | Short Description | Value |
|        ----             |      ----         |  ---- |
| apiRootUrl | mHealthAtlas gateway base url |  <https://mhealthatlas-gateway:5555/mhealthatlas> |
| keycloak.issuer | the access token issuer url | <https://keycloak-proxy:5506/auth/realms/MHealthAtlas> |
| keycloak.redirectUri | the redirect url (after a successful log in or regestration) | <https://mhealthatlas:5556/> |
| keycloak.clientId | the keycloak client used for the authentication | mhealthatlas-login |
| keycloak.responseType | the oauth2 flow | code |
| keycloak.scope | the requested scope | openid |
| keycloak.requireHttps | enables https request when communicating with keycloak | true |
| keycloak.showDebugInformation | enables the output of debug informations | false |
