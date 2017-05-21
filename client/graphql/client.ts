import { ApolloClient, createNetworkInterface } from 'react-apollo'


const networkInterface = createNetworkInterface({
  uri: window.location.origin + '/graphql',
  opts: {

    credentials: 'include'
  }
})

export default new ApolloClient({
  networkInterface: networkInterface,
  reduxRootSelector: (state) => state.apollo
})