import { createStore, applyMiddleware } from 'redux'
import thunkMiddleware from 'redux-thunk'
import {default as app} from './reducers/reducers'

export default function configureStore(preloadedState) {
  return createStore(
    app,
    preloadedState,
    applyMiddleware(
      thunkMiddleware,
    )
  )
}