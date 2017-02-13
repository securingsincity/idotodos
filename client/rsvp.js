import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import RSVPContainer from './containers/RsvpContainer'
import configureStore from './configureStore'
import { Provider } from 'react-redux'
let store = configureStore()

ReactDOM.render( <Provider store={store}>
    <RSVPContainer />
  </Provider>, document.getElementById("rsvp-app"))