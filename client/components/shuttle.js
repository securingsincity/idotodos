import React, { Component } from 'react';
import {FormGroup, FormControl, ControlLabel, HelpBlock, Radio} from 'react-bootstrap'
class Shuttle extends Component {
  render() {
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">RSVP To Shuttle</ControlLabel>
          <div className="col-sm-3">
              <Radio checked={this.props.shuttle == true } onChange={() => this.props.setShuttle(true)} inline>
                Yes
              </Radio>
              {' '}
              <Radio checked={this.props.shuttle !== true}  onChange={() => this.props.setShuttle(false)} inline>
                No
              </Radio>
          </div>
          <FormControl.Feedback />
          <HelpBlock></HelpBlock>

        </FormGroup>
      </div>
    );
  }
}

export default Shuttle;