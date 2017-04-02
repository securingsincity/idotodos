import { connect } from 'react-redux'
import RSVP from '../components/rsvp.js'
import { formValueSelector, submit } from 'redux-form';
import _ from 'lodash'
import {
  onResponse,
  showConfirmModal,
  hideConfirmModal,
} from '../actions/rsvp.js'
const selector = formValueSelector('rsvpForm')
const mapStateToProps = (state) => {
  return {
    guests: selector(state, 'guests'),
    maxGuests:  selector(state, 'maxGuests'),
    showModal: state.rsvp.showConfirmModal,
    submitting: _.get(state,'form.rsvpForm.submitting', false),
    submitFailed: _.get(state,'form.rsvpForm.submitFailed', false),
    responded: state.rsvp.responded
  }
}
const mapDispatchToProps = (dispatch) => {
  return {
    onResponse: () => {
      dispatch(onResponse())
    },
    showConfirmModal: () => {
      dispatch(showConfirmModal())
    },
    hideConfirmModal: () => {
      dispatch(hideConfirmModal())
    },
    onNoOfConfirmModal: () => {
      dispatch(hideConfirmModal())
    },
    onYesOfConfirmModal: () => {
      dispatch(submit('rsvpForm'))
      dispatch(hideConfirmModal())
    }

  }
}
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RSVP)
