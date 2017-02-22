
import Immutable, { Map, fromJS } from 'immutable';
const uuidV4 = require('uuid/v4');

const initialState = fromJS({
  guests: [],
  songChoices: [],
  maxGuests: 0,
})
export default function rsvp(state = initialState, action) {
  // For now, don't handle any actions
  // and just return the state given to us.
  const guests = state.get("guests")
  switch (action.type) {
    case "FIRST_NAME_CHANGED":
      const index = guests.findIndex(function(item) {
        return item.get("id") === action.id;
      })
      if (index === -1) {
        return state
      }
      const updatedGuests = guests.update(index, function(item) {
          return item.set("firstName", action.name)
        }
      );
      return state.set("guests", updatedGuests);
    case "LAST_NAME_CHANGED":
      const userIndex = guests.findIndex(function(item) {
        return item.get("id") === action.id;
      })
      if (userIndex === -1) {
        return state
      }
      const updatedGuestsWithLastNameChange = guests.update(userIndex, function(item) {
          return item.set("lastName", action.name)
        }
      );
      return state.set("guests", updatedGuestsWithLastNameChange);
    case "ATTENDING_CHANGED":
      const guestIndex = guests.findIndex(function(item) {
        return item.get("id") === action.id;
      })
      if (guestIndex === -1) {
        return state
      }
      const updatedGuestsWithAttendingChange = guests.update(guestIndex, function(item) {
          return item.set("attending", action.isAttending)
        }
      );
      return state.set("guests", updatedGuestsWithAttendingChange);
    case "ADD_GUEST":
      const guestsPlusOne = guests.push(Immutable.Map({id: uuidV4() }))
      return state.set("guests", guestsPlusOne)
    case "INITIAL_LOAD":
      const withGuests = state.set("guests", Immutable.fromJS(action.guests))
      const loaded = withGuests.set("maxGuests", action.maxGuests)
      return loaded
    default:
      return state
  }
}
