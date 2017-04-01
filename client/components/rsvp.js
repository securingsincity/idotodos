import React, {Component} from 'react'
import {Button} from 'react-bootstrap'
// import _ from 'lodash'
import Guest from '../components/guest'
import SongRequest from '../components/songRequest'
import Shuttle from '../components/shuttle'
import { fromJS } from 'immutable'
export default class RSVP extends Component {
  constructor(props) {
    super(props)
    this.onClick = this.onClick.bind(this)
    this.addGuest = this.addGuest.bind(this)
  }
  onClick() {
    this.props.sendRSVP()
  }
  addGuest() {
    this.props.addGuest()
  }
  componentDidMount() {
    const { initialData } = this.props
    initialData()
  }

  render() {
    var self = this;
    const someGuestsAreAttending = this.props.guests.some((guest) => guest.get('attending'))
    return (
      <div className="col-sm-12">
        <form className="form-horizontal">
          {this.props.guests.map(function(guest) {
            let guestErrors = fromJS({
              firstName: false,
              lastName: false
            });
            if (this.props.hasErrors) {
              guestErrors = this.props.guestErrors.find((guestError) => guestError.get('id') === guest.get('id'))
            }
            return <Guest
            key={guest.get("id")}
            id={guest.get("id")}
            guestErrors={guestErrors}
            onLastNameChange={self.props.onLastNameChange}
            onFirstNameChange={self.props.onFirstNameChange}
            setAttending={self.props.setAttending}
            setAllergies={self.props.setAllergies}
            setMealChoice={self.props.setMealChoice}
            firstName={guest.get("firstName")}
            attending={guest.get("attending")}
            mealChoice={guest.get("mealChoice")}
            mealChoices={guest.get("mealChoices")}
            allergies={guest.get("allergies")}
            lastName={guest.get("lastName")} />
          }, this)}
          {(someGuestsAreAttending) ?
            (<div>
                <Shuttle shuttle={this.props.shuttle} setShuttle={ this.props.setShuttle}/>
                <SongRequest {...this.props} />
            </div>): <div />}
          <div className="row">
            {this.props.maxGuests > this.props.guests.size ? <Button onClick={this.addGuest}>Add Guest</Button>: ""}

            <Button bsStyle="success" onClick={this.onClick}>{"RSVP "}<i className="star" /></Button>
          </div>
        </form>
      </div>
    );
  }
}