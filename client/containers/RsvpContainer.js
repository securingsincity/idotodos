import { connect } from 'react-redux'
import RSVP from '../components/rsvp.js'
import { formValueSelector } from 'redux-form';
import {
  requestSong
} from '../actions/rsvp.js'
const selector = formValueSelector('rsvpForm')
const mapStateToProps = (state) => {
  return {
    guests: selector(state, 'guests'),
    maxGuests:  selector(state, 'maxGuests')
  }
}
const mapDispatchToProps = (dispatch) => {
  return {
    requestSong: (songName) => {
      dispatch(requestSong(songName))
    }
  }
}
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RSVP)
