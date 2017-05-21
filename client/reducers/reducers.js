import { combineReducers } from 'redux'
import rsvp from './rsvp'
import { reducer as formReducer } from 'redux-form'
import { routerReducer } from 'react-router-redux'
const client = require('../graphql/client').default
export default combineReducers({
  rsvp: rsvp,
  form: formReducer,
  router: routerReducer,
  apollo: client.reducer(),
})

