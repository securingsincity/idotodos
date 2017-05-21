import * as React from 'react';
import * as ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import createHistory from 'history/createHashHistory'
import { Route, Link, match } from 'react-router-dom'
import GuestsContainer from './containers/GuestsContainer'
import GuestContainer from './containers/GuestContainer'
import { ConnectedRouter, routerReducer, routerMiddleware, push } from 'react-router-redux'
import { ApolloClient, ApolloProvider } from 'react-apollo';
// Create a history of your choosing (we're using a browser history in this case)
const history = createHistory()
const client = require('./graphql/client.ts').default
import configureStore from './configureStore'
let store = configureStore()


const Home = () => (
  <div>
    <h2>Home</h2>
  </div>
)
const Guests = () => (
  <div>
    <h2>Guests</h2>
  </div>
)
const Invites = () => (
  <div>
    <h2>Invites</h2>
  </div>
)
const Website = () => (
  <div>
    <h2>Website</h2>
  </div>
)
const SideNav = (props: any) => {
  const { location } = props
  return (
  <div className="col-sm-2">
    <div className="list-group">
    <Link className={"list-group-item "+ (location.pathname === '/' ? "active" : '')} to="/">Home</Link>
    <Link className={"list-group-item "+ (location.pathname.indexOf('/guests') >= 0 ? "active" : '')} to="/guests">Guests</Link>
    <Link className={"list-group-item "+ (location.pathname.indexOf('/invites') >= 0 ? "active" : '')} to="/invites">Invites</Link>
    <Link className={"list-group-item "+ (location.pathname.indexOf('/website') >= 0 ? "active" : '')} to="/website">Website</Link>
    </div>
  </div>
)}



ReactDOM.render(
<Provider store={store}>
   <ApolloProvider store={store} client={client}>
   <ConnectedRouter history={history}>
      <div className="row">
        <Route component={SideNav} />
        <div className="col-sm-10">
          <Route path="/" exact component={Home} />
          <Route path="/guests/:id" component={GuestContainer} />
          <Route exact path="/guests" component={GuestsContainer} />
          <Route path="/invites" component={Invites} />
          <Route path="/website" component={Website} />
        </div>
      </div>
    </ConnectedRouter>
    </ApolloProvider>
</Provider>, document.getElementById("admin-app"))