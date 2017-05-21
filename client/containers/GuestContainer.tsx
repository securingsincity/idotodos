import * as React from 'react';
import { connect } from 'react-redux'
import Guest from '../components/admin/guest'
export interface GuestContainerProps {
}

class GuestContainer extends React.Component<GuestContainerProps, any> {
  render() {
    return (
      <div>
        <Guest />
      </div>
    );
  }
}

const mapState2Props = state => {
  return {
  };
}

export default connect(mapState2Props)(GuestContainer);
