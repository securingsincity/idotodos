import React, { Component } from 'react';
import RSVPForm from './rsvpForm'
import _ from 'lodash'
import axios from 'axios'
import { ConfirmModal } from 'react-maxwell-modal';

export default class RSVP extends React.Component {
  constructor(props) {
    super(props)
    this.submit = this.submit.bind(this)
  }
  submit(values) {
    // Do something with the form values
    const onResponse = this.props.onResponse
    return axios.post(`/api/wedding/${window.weddingName}/rsvp`, values)
    .then((response) => {
      if (response.data.success == false) {
        throw Error('There was an issue submitting your form please retry')
      }
      onResponse()
      return true
    })
  }
  render() {
    const alreadyResponded = _.some(window.data.guests, (guest) => guest.responded)
    const hasResponded = this.props.responded
    let content = <RSVPForm onSubmit={this.submit} {...this.props} />
    if (hasResponded) {
      content = <div>Thanks! We've sent the information off to the happy couple.</div>
    } else if (alreadyResponded) {
      content = <div>You've already responded if you need to change your RSVP please contact the happy couple.</div>
    }
    return (
      <div>
      {content}
      <ConfirmModal
        title={"Are you sure you are ready to RSVP?"}
        isOpen={this.props.showModal}
        shouldCloseOnOverlayClick={false}
        onHide={this.props.hideConfirmModal}
        onYes={this.props.onYesOfConfirmModal}
        onNo={this.props.onNoOfConfirmModal}
        noLabel={'Not yet'}
        yesLabel={<span>RSVP<span className="glyphicon glyphicon-menu-right" aria-hidden="true"></span></span>}
      >
        <span>Please confirm, are you ready to send your RSVP?</span>
      </ConfirmModal>
      </div>
    );
  }
}