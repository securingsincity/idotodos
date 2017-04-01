import React, { Component } from 'react';
import RSVPForm from './rsvpForm'
export default class RSVP extends React.Component {
  submit(values) {
    // Do something with the form values
    console.log(values);
  }
  render() {
    return (
      <RSVPForm onSubmit={this.submit} {...this.props} />
    );
  }
}