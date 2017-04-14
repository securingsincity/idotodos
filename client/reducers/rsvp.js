
import { creators } from '../actions/rsvp'
import { assign } from 'lodash'
const initialState = {
  responded: false,
  showConfirmModal: false,
}
export default function rsvp(state = initialState, action) {
  switch (action.type) {
    case creators.RESPONDED:
      return assign({}, state, {responded: true})
      break;
    case creators.SHOW_CONFIRM_MODAL:
      return assign({}, state, {showConfirmModal: true})
      break;
    case creators.HIDE_CONFIRM_MODAL:
      return assign({}, state, {showConfirmModal: false})
      break;
    default:
      return state
  }
}
