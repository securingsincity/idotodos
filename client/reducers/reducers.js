import { combineReducers } from 'redux'
import rsvp from './rsvp'
import { reducer as formReducer } from 'redux-form'

export default combineReducers({
  rsvp: rsvp,
  form: formReducer,
})

