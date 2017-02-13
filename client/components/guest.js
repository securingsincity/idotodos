import React, {Component} from 'react';
import {FormGroup, FormControl, ControlLabel, HelpBlock} from 'react-bootstrap'
class Guest extends Component {
  constructor(props) {
    super(props)
    this.onFirstNameChange = this.onFirstNameChange.bind(this)
    this.onLastNameChange = this.onLastNameChange.bind(this)
  }
  onFirstNameChange(e) {
    this.props.onFirstNameChange(this.props.id, e.target.value);
  }
  onLastNameChange(e) {
    this.props.onLastNameChange(this.props.id, e.target.value);
  }
  render() {
    let fullName = "Your Guest"
    if (this.props.firstName && this.props.lastName) {
      fullName = this.props.firstName +" "+this.props.lastName
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
              placeholder="Enter text"
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
            placeholder="Enter text"
            onChange={this.onLastNameChange}
          />
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>

        </FormGroup>

      </div>
    );
  }
}

export default Guest;