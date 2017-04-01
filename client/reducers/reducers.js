import { combineReducers } from 'redux'
import rsvp from './rsvp'
import errors from './errors'
export default combineReducers({
  rsvp: rsvp,
  errors: errors,
})

