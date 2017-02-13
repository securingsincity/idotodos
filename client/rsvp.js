import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import RSVPContainer from './containers/RsvpContainer'
import configureStore from './configureStore'

import { Provider } from 'react-redux'
import '../web/static/css/app.scss'
import "phoenix_html"
let store = configureStore()
// this is a comment
ReactDOM.render( <Provider store={store}>
    <RSVPContainer />
  </Provider>, document.getElementById("rsvp-app"))