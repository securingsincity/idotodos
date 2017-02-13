import { connect } from 'react-redux'
import RSVP from '../components/rsvp.js'
import {initialLoad, onFirstNameChange, onLastNameChange, addGuest} from '../actions/rsvp.js'
const mapStateToProps = (state, ownProps) => {
  return {
    guests: state.rsvp.get("guests"),
    maxGuests: state.rsvp.get("maxGuests"),
    songChoices: state.rsvp.get("songChoices"),
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
    }
  }
}
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RSVP)
