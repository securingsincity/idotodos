import React, { Component } from 'react';
import { FormGroup, FormControl, ControlLabel, HelpBlock } from 'react-bootstrap'
class FormControlInput extends Component {
  render() {
    const { meta: {touched, submitFailed, error}} = this.props
    return (
      <FormGroup
            controlId="formBasicText"
            className={((touched || submitFailed) && error ) ? 'has-error' : ''}
          >
        <ControlLabel className="col-sm-2 control-label">{this.props.label}</ControlLabel>
        <div className="col-sm-10">
          <FormControl
            className="form-control"
            value={this.props.input.value}
            type="text"
            placeholder={this.props.label}
            onChange={this.props.input.onChange}
          />
        </div>
        <FormControl.Feedback />
        <HelpBlock>{(touched || submitFailed) && error && <span>{error}</span>}</HelpBlock>
      </FormGroup>
    );
  }
}

export default FormControlInput;