import axios from 'axios'
import Immutable from 'immutable'
import { validateForm } from '../utils/validation'
export function initialLoad(guests, maxGuests) {
  return {type: creators.INITIAL_LOAD, guests, maxGuests}
}

export function onFirstNameChange(id, name) {
  return {type: creators.FIRST_NAME_CHANGED, id, name}
}

export function onLastNameChange(id, name) {
  return {type: creators.LAST_NAME_CHANGED, id, name}
}

export function setAttending(id, isAttending) {
  return {type: creators.ATTENDING_CHANGED, id, isAttending}
}

export function setAllergies(id, allergies) {
  return {type: creators.ALLERGIES_CHANGED, id, allergies}
}

export function setMealChoice(id, mealChoice) {
  return {type: creators.MEAL_CHOICE_CHANGED, id, mealChoice}
}

export function addGuest() {
  return {type: creators.ADD_GUEST}
}

export function setShuttle(shuttle) {
  return {type: creators.SHUTTLE_CHANGED, shuttle}
}

export function requestSong(songs) {
  return (dispatch, getState) => {
    dispatch({type: creators.SONGS_CHANGED, songs: Immutable.List(songs)})
  }
}

export const creators = {
  INITIAL_LOAD: "INITIAL_LOAD",
  FIRST_NAME_CHANGED: "FIRST_NAME_CHANGED",
  LAST_NAME_CHANGED: "LAST_NAME_CHANGED",
  ATTENDING_CHANGED: "ATTENDING_CHANGED",
  ALLERGIES_CHANGED: "ALLERGIES_CHANGED",
  MEAL_CHOICE_CHANGED: "MEAL_CHOICE_CHANGED",
  ADD_GUEST: "ADD_GUEST",
  SHUTTLE_CHANGED: "SHUTTLE_CHANGED",
  SPOTIFY_SONG_REQUEST: "SPOTIFY_SONG_REQUEST",
  SPOTIFY_SONG_SUCCESS: "SPOTIFY_SONG_SUCCESS",
  SPOTIFY_SONG_FAILURE: "SPOTIFY_SONG_FAILURE",
  SONGS_CHANGED: "SONGS_CHANGED",
  SET_ERRORS: "SET_ERRORS",
  CLEAR_ERRORS: "CLEAR_ERRORS"
}

export function sendRSVP() {
  return (dispatch, getState) => {
    const values = getState().rsvp.toJS()
    const errors = validateForm(values)
    if (errors.hasErrors) {
      dispatch({type: creators.SET_ERRORS, errors})
      return
    }
    console.log(values)
  }
}