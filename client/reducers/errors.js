import Immutable, { Map, fromJS } from 'immutable';
import {creators} from '../actions/rsvp'

const initialState  = fromJS({
  hasErrors: false,
  guests: []
})

export default function errors(state = initialState, action) {
  switch (action.type) {
    case creators.SET_ERRORS:
      return fromJS(action.errors)
    default:
      return state
  }
}