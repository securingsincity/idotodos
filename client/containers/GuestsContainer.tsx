import * as React from 'react';
import { connect } from 'react-redux'
import { gql, graphql } from 'react-apollo';
import { Link } from 'react-router-dom'
export interface GuestsProps {
}
const GuestsQuery = gql`
  query parties {
    campaigns {
      parties {
        name
        maxPartySize
        guests {
          id
          firstName
          lastName
        }
        id
      }
    }
  }
`;

class Guests extends React.Component<any, any> {
  render() {
    const {data}  = this.props
    const campaign = data.campaigns ? data.campaigns[0] : {parties: []}
    return (
      <div>
        <h2>Parties</h2>
        <table className="table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Max party size</th>
                    <th>Guests</th>
                    <th></th>
                </tr>
            </thead>
          <tbody>
            {campaign.parties.map((party:any) => {
              return (
                <tr key={party.id}>
                  <td>{party.name}</td>
                  <td>{party.maxPartySize}</td>
                  <td>
                      <ul>
                      {party.guests.map((guest:any) => <li key={guest.id}>{guest.firstName + " " + guest.lastName}</li>)}
                      </ul>
                  </td>
                  <td>
                    <Link to={`/guests/${party.id}`}>Edit</Link>
                  </td>
              </tr>

              )
            })}
          </tbody>
          </table>
      </div>
    );
  }
}

const mapState2Props = (state:any) => {
  return {
  };
}
//
export default connect(mapState2Props)(graphql(GuestsQuery)(Guests));
