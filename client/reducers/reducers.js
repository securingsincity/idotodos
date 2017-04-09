import { combineReducers } from 'redux'
import rsvp from './rsvp'
import { reducer as formReducer } from 'redux-form'
import { routerReducer } from 'react-router-redux'
export default combineReducers({
  rsvp: rsvp,
  form: formReducer,
  router: routerReducer,
})

