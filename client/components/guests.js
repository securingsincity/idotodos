import React, { Component } from 'react';
import { Field } from 'redux-form'
import Allergies from './allergies'
import YesNo from './yesNo'
import FormControlInput from './FormControlInput'
import _ from 'lodash'
import { Button } from 'react-bootstrap'
class Guests extends Component {
  render() {
    const guestsData = !_.isEmpty(this.props.guests) ? this.props.guests : [{}]
    const fields = this.props.fields
    const guests = this.props.fields.map(function (guest, index) {
      const guestData = guestsData[index]
      let fullName = "Your Guest"
      if (guestData && guestData.firstName && guestData.lastName) {
        fullName = guestData.firstName + " " + guestData.lastName
      }
      return (
        <div key={guest} className={'guest-wrapper'}>
          <h4>{fullName}</h4>
          <Field component={FormControlInput} name={`${guest}.firstName`} label={'First Name'} />
          <Field component={FormControlInput} name={`${guest}.lastName`} label={'Last Name'} />
          <Field component={YesNo} name={`${guest}.attending`} label="Attending" />
          {(guestData && guestData.attending) ? (<Field component={Allergies} name={`${guest}.allergies`} />) : ''}
          {(guestData && guestData.attending) ? (<Field component={YesNo} name={`${guest}.shuttle`} label="RSVP To Shuttle"/>) : ''}
          {(guestData && guestData.id) ? <div /> : (<Button className="margin-bottom-20" onClick={() => fields.remove(index)}>Remove Guest</Button>)}
        </div>
      )
    }, this)

    return (
      <div>

        {guests}
        {
          (!_.isEmpty(this.props.guests) && (this.props.maxGuests > this.props.guests.length)) ?
            (<Button className="margin-bottom-20" onClick={() => this.props.fields.push({ attending: true, shuttle: false, allergies: '' })}>Add Guest</Button>)
            : ''
        }
      </div>
    );
  }
}

export default Guests;