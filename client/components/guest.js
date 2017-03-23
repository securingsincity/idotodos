import React, {Component} from 'react';
import Allergies from './allergies'
import MealChoice from './mealChoice'
import {FormGroup, FormControl, ControlLabel, HelpBlock, Radio} from 'react-bootstrap'
class Guest extends Component {
  constructor(props) {
    super(props)
    this.onFirstNameChange = this.onFirstNameChange.bind(this)
    this.onLastNameChange = this.onLastNameChange.bind(this)
    this.setAttending = this.setAttending.bind(this)
    this.setAllergies = this.setAllergies.bind(this)
    this.setMealChoice = this.setMealChoice.bind(this)
  }
  onFirstNameChange(e) {
    this.props.onFirstNameChange(this.props.id, e.target.value);
  }
  onLastNameChange(e) {
    this.props.onLastNameChange(this.props.id, e.target.value);
  }
  setAttending(isAttending) {
    this.props.setAttending(this.props.id, isAttending)
  }
  setAllergies(e) {
    this.props.setAllergies(this.props.id, e.target.value)
  }
  setMealChoice(e) {
    this.props.setMealChoice(this.props.id,  e.value)
  }
  render() {
    let fullName = "Your Guest"
    if (this.props.firstName && this.props.lastName) {
      fullName = this.props.firstName +" "+this.props.lastName
    }
    let allergies = <div />;
    let mealChoice = <div />;
    if (this.props.attending) {
      allergies = <Allergies allergies={this.props.allergies} onChange={this.setAllergies}/>
      mealChoice = <MealChoice mealChoice={this.props.mealChoice} onChange={this.setMealChoice} mealChoices={this.props.mealChoices}/>
    }
    return (
       <div>
       <h4>{fullName}</h4>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">First Name</ControlLabel>
          <div className="col-sm-10">
            <FormControl
              type="text"
              value={this.props.firstName}
              placeholder="First Name"
              onChange={this.onFirstNameChange}
            />
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>
        </FormGroup>

        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Last Name</ControlLabel>
          <div className="col-sm-10">
          <FormControl
            type="text"
            value={this.props.lastName}
            placeholder="Last Name"
            onChange={this.onLastNameChange}
          />
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>

        </FormGroup>

        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Attending</ControlLabel>
          <div className="col-sm-3">
              <Radio checked={this.props.attending == true } onChange={() => this.setAttending(true)} inline>
                Yes
              </Radio>
              {' '}
              <Radio checked={this.props.attending !== true}  onChange={() => this.setAttending(false)} inline>
                No
              </Radio>
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>

        </FormGroup>
        {allergies}
        {mealChoice}
      </div>
    );
  }
}

export default Guest;