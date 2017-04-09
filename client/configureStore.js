import { createStore, applyMiddleware, compose, combineReducers } from 'redux'
import thunkMiddleware from 'redux-thunk'
import {default as app} from './reducers/reducers'
import createHistory from 'history/createBrowserHistory'

import { routerReducer, routerMiddleware } from 'react-router-redux'
// Create a history of your choosing (we're using a browser history in this case)
const history = createHistory()
// Build the middleware for intercepting and dispatching navigation actions
const middleware = routerMiddleware(history)
export default function configureStore(preloadedState) {
  return createStore(
    combineReducers({
      ...app,
      router: routerReducer
    }),
    preloadedState,
    compose(
      applyMiddleware(
        thunkMiddleware,
        middleware
      ),
      window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(),
    )
  )
}