import React, { Component } from 'react';
import Select from 'react-select';
import axios from 'axios'
import { debounce } from 'lodash'
// Be sure to include styles at some point, probably during your bootstrapping
import 'react-select/dist/react-select.css'
import { FormGroup, ControlLabel } from 'react-bootstrap'

const options = [
    { value: 'one', label: 'One' },
    { value: 'two', label: 'Two' }
];
export function parseTracks(items){
  return items.map((item) => {
    return {
      value: item.name + " by " + item.artists[0].name,
      label: item.name + " by " + item.artists[0].name,
    }
  })
}
const loadOptions = debounce((input, callback) => {
  if (!input) {
    callback(null, [])
  }
  axios.get('https://api.spotify.com/v1/search', {
    params: {
      q: input,
      type: 'track'
    }
  })
  .then(function (response) {
    const tracks = parseTracks(response.data.tracks.items);
    callback(null, {options: tracks})
  })
  .catch(function (error) {
    callback(null, [])
  });
}, 500)

class SongRequest extends Component {
  render() {
    return (
      <div>
        <FormGroup
          controlId="formBasicText"
        >
          <ControlLabel className="col-sm-2 control-label">Song Requests</ControlLabel>
          <div className="col-sm-10">
            <Select.AsyncCreatable autoload={false} multi={true} delimiter={'%'} value={this.props.songs.toJS()} onChange={this.props.requestSong} loadOptions={loadOptions} />
        </div>
        </FormGroup>
      </div>
    );
  }
}

export default SongRequest;