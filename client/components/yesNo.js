import React, { Component } from 'react';
import { FormGroup, FormControl, ControlLabel, HelpBlock, Radio } from 'react-bootstrap'

class YesNo extends Component {
  render() {
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">{this.props.label}</ControlLabel>
          <div className="col-sm-3">
            <Radio checked={this.props.input.value == true} onChange={() => this.props.input.onChange(true)} inline>
              Yes
              </Radio>
            {' '}
            <Radio checked={this.props.input.value !== true} onChange={() => this.props.input.onChange(false)} inline>
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

export default YesNo