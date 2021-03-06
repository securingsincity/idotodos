import React, {Component} from 'react'
import {Button} from 'react-bootstrap'
import _ from 'lodash'
import SongRequest from './songRequest'
import { Field, FieldArray, reduxForm } from 'redux-form';
import Guests from './guests'
import {validateForm} from '../utils/validation'
class RSVP extends Component {
  render() {
    const someGuestsAreAttending = _.some(this.props.guests, (guest) => guest.attending)
    // const { handleSubmit } = this.props
    return (
      <div className="col-sm-12">
        <form className="form-horizontal">
          <FieldArray name="guests" component={Guests} guests={this.props.guests} maxGuests={this.props.maxGuests}/>
          {(someGuestsAreAttending) ?
            (<div className="text-left">
                <Field component={SongRequest} name="songs" />
            </div>): <div />}
          <div className="row">
            {this.props.submitFailed ? <div className="alert alert-danger">There was an issue submitting your form please retry</div> : ''}
            <Button bsStyle="success" disabled={this.props.submitting} onClick={this.props.showConfirmModal}>RSVP <span className="glyphicon glyphicon-menu-right" aria-hidden="true"></span></Button>
          </div>
        </form>
      </div>
    );
  }
}

const RSVPForm = reduxForm({
  form: 'rsvpForm', // a unique name for this form
  initialValues: Object.assign(window.data, {
    songs: []
  }),
  validate: validateForm
})(RSVP);

export default RSVPForm