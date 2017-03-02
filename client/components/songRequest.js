import React, { Component } from 'react';
import Select from 'react-select';

// Be sure to include styles at some point, probably during your bootstrapping
import 'react-select/dist/react-select.css'


const options = [
    { value: 'one', label: 'One' },
    { value: 'two', label: 'Two' }
];


class SongRequest extends Component {
  render() {
    return (
      <div>

        <Select
            name="form-field-name"
            value="one"
            options={options}
            // onChange={logChange}
        />
      </div>
    );
  }
}

export default SongRequest;