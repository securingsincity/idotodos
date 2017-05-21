import { createStore, applyMiddleware, compose, combineReducers } from 'redux'
import thunkMiddleware from 'redux-thunk'
import {default as app} from './reducers/reducers'
import createHistory from 'history/createBrowserHistory'
const client = require('./graphql/client').default
import { routerMiddleware } from 'react-router-redux'
// Create a history of your choosing (we're using a browser history in this case)
const history = createHistory()
// Build the middleware for intercepting and dispatching navigation actions
const middleware = routerMiddleware(history)
export default function configureStore(preloadedState) {
  return createStore(
    app,
    preloadedState,
    compose(
      applyMiddleware(
       client.middleware(),
        thunkMiddleware,
        middleware
      ),
      (typeof window.__REDUX_DEVTOOLS_EXTENSION__ !== 'undefined') ? window.__REDUX_DEVTOOLS_EXTENSION__() : f => f,
    )
  )
}