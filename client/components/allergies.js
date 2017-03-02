import React, { Component } from 'react';
import {FormGroup, FormControl, ControlLabel, HelpBlock, Radio} from 'react-bootstrap'
class Allergies extends Component {
  render() {
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Please List Any Allergies</ControlLabel>
          <div className="col-sm-10">
            <FormControl
              type="text"
              value={this.props.allergies}
              placeholder="Enter text"
              onChange={this.props.onChange}
            />
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>
        </FormGroup>
      </div>
    );
  }
}

export default Allergies;