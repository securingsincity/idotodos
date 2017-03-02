import { connect } from 'react-redux'
import RSVP from '../components/rsvp.js'
import {initialLoad, setAttending, onFirstNameChange, onLastNameChange, addGuest, setMealChoice, setAllergies} from '../actions/rsvp.js'
const mapStateToProps = (state, ownProps) => {
  return {
    guests: state.rsvp.get("guests"),
    maxGuests: state.rsvp.get("maxGuests"),
    songChoices: state.rsvp.get("songChoices"),
    mealChoices: state.rsvp.get("mealChoices"),
    mealChoice: state.rsvp.get("mealChoice"),
    allergies: state.rsvp.get("allergies"),
  }
}
const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    initialData: () => {
      dispatch(initialLoad(window.data.guests, window.data.maxGuests))
    },
    onFirstNameChange: (id, name) => {
      dispatch(onFirstNameChange(id, name))
    },
    onLastNameChange: (id, name) => {
      dispatch(onLastNameChange(id, name))
    },
    addGuest: () => {
      dispatch(addGuest())
    },
    setAttending: (id, isAttending) => {
      dispatch(setAttending(id, isAttending))
    },
    setAllergies: (id, allergies) => {
      dispatch(setAllergies(id, allergies))
    },
    setMealChoice: (id, mealChoice) => {
      dispatch(setMealChoice(id, mealChoice))
    }
  }
}
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RSVP)
