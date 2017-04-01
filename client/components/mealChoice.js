import React, { Component } from 'react';
import {FormGroup, FormControl, ControlLabel, HelpBlock} from 'react-bootstrap'
import Select from 'react-select'
class MealChoice extends Component {
  render() {
    // const options = this.props.mealChoices.map((meal) => {
    const options = ['beef', 'chicken'].map((meal) => {
      return {label: meal, value: meal};
    })
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Meal Choice</ControlLabel>
          <div className="col-sm-10">
            <Select
              name="mealChoice"
              value={this.props.mealChoice}
              options={options}
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

export default MealChoice;