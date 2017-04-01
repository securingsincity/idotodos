import React, { Component } from 'react';
import { FormGroup, FormControl, ControlLabel, HelpBlock } from 'react-bootstrap'
class Allergies extends Component {
  render() {
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Please List Any Dietary Restrictions</ControlLabel>
          <div className="col-sm-10">
            <FormControl
              type="text"
              value={this.props.input.value}
              placeholder="Please List Any Dietary Restrictions"
              onChange={this.props.input.onChange}
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