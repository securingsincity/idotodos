import React, { Component } from 'react';
import RSVPForm from './rsvpForm'
import _ from 'lodash'
import axios from 'axios'
export default class RSVP extends React.Component {
  submit(values) {
    // Do something with the form values
    axios.post(`/api/wedding/${window.weddingName}/rsvp`, values)
    .then((response) => {
      console.log(response);
    })

  }
  render() {
    const alreadyResponded = _.some(window.data.guests, (guest) => guest.responded)
    return (
      alreadyResponded ? <div>You've already responded if you need to change your RSVP please contact the bride and groom</div> : (<RSVPForm onSubmit={this.submit} {...this.props} />)
    );
  }
}