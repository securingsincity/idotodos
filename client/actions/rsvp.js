export function initialLoad(guests, maxGuests) {
  return {type: "INITIAL_LOAD", guests, maxGuests}
}

export function onFirstNameChange(id, name) {
  return {type: "FIRST_NAME_CHANGED", id, name}
}

export function onLastNameChange(id, name) {
  return {type: "LAST_NAME_CHANGED", id, name}
}

export function setAttending(id, isAttending) {
  return {type: "ATTENDING_CHANGED", id, isAttending}
}

export function setAllergies(id, allergies) {
  return {type: "ALLERGIES_CHANGED", id, allergies}
}

export function setMealChoice(id, mealChoice) {
  return {type: "MEAL_CHOICE_CHANGED", id, mealChoice}
}

export function addGuest() {
  return {type: "ADD_GUEST"}
}

export function setShuttle(shuttle) {
  return {type: "SHUTTLE_CHANGED", shuttle}
}

export function sendRSVP() {
  return (dispatch, getState) => {
    console.log(getState().rsvp.toJS());
  }
}