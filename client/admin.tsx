import * as React from 'react';
import * as ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import createHistory from 'history/createHashHistory'
import { Route } from 'react-router-dom'

import { ConnectedRouter, routerReducer, routerMiddleware, push } from 'react-router-redux'

// Create a history of your choosing (we're using a browser history in this case)
const history = createHistory()

import configureStore from './configureStore'
let store = configureStore()


const Home = () => (
  <div>
    <h2>Home</h2>
  </div>
)



ReactDOM.render(
<Provider store={store}>
   <ConnectedRouter history={history}>
      <Route path="/" component={Home}/>
    </ConnectedRouter>
</Provider>, document.getElementById("admin-app"))