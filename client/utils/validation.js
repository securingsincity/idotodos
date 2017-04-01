import _ from 'lodash'
export function validateForm(values) {
  const errors = {}
  const guestsErrors = values.guests.reduce((acc, guest) => {
    const guestErrors = validateUser(guest)
    acc.push(guestErrors)
    return acc
  }, [])
  const thereAreGuestErrors = _.some(guestsErrors, (guest) => guest.hasErrors)
  if (thereAreGuestErrors) {
    errors.guests = guestsErrors
  }
  return errors
}

export function validateUser(user) {
  const userErrors = {}
  if (!user || !user.firstName) {
    userErrors.firstName = 'Required'
    userErrors.hasErrors = true
  }
  if (!user || !user.lastName) {
    userErrors.lastName = 'Required'
    userErrors.hasErrors = true
  }
  return userErrors
}