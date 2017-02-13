export function initialLoad(guests, maxGuests) {
  return {type: "INITIAL_LOAD", guests, maxGuests}
}

export function onFirstNameChange(id, name) {
  return {type: "FIRST_NAME_CHANGED", id, name}
}

export function onLastNameChange(id, name) {
  return {type: "LAST_NAME_CHANGED", id, name}
}

export function addGuest() {
  return {type: "ADD_GUEST"}
}