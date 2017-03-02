import React, {Component} from 'react'
import {Button} from 'react-bootstrap'
// import _ from 'lodash'
import Guest from '../components/guest'
import SongRequest from '../components/songRequest'

export default class RSVP extends Component {
  constructor(props) {
    super(props)
    this.onClick = this.onClick.bind(this)
    this.addGuest = this.addGuest.bind(this)
  }
  onClick() {
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
    return (
      <div className="col-sm-12">
        <form className="form-horizontal">
          max guests: {this.props.maxGuests}
          {this.props.guests.map(function(guest) {
            return <Guest
            key={guest.get("id")}
            id={guest.get("id")}
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
          })}
          <SongRequest />
          {this.props.maxGuests > this.props.guests.size ? <Button onClick={this.addGuest}>Add Guest</Button>: ""}

          <Button bsStyle="success" onClick={this.onClick}>Success</Button>

        </form>
      </div>
    );
  }
}