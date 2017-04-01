import { createStore, applyMiddleware, compose } from 'redux'
import thunkMiddleware from 'redux-thunk'
import {default as app} from './reducers/reducers'

export default function configureStore(preloadedState) {
  return createStore(
    app,
    preloadedState,
    compose(
      applyMiddleware(
        thunkMiddleware,
      ),
      window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(),
    )
  )
}