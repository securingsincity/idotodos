import _ from 'lodash'
export function validateForm(state) {
  const guestErrors = state.guests.map((guest) => validateUser(guest))
  return {
    hasErrors: _.some(guestErrors, (guest) => guest.hasErrors),
    guests: guestErrors
  }
}

export function validateUser(user) {
  return {
    id: user.id,
    firstName: _.isEmpty(user.firstName),
    lastName: _.isEmpty(user.lastName),
    hasErrors:  _.isEmpty(user.firstName) ||  _.isEmpty(user.lastName)
  }
}