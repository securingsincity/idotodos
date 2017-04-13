import * as React from 'react';
import { connect } from 'react-redux'

export interface GuestListContainerProps {
}

class GuestListContainer extends React.Component<GuestListContainerProps, any> {
  render() {
    return (
      <div>
        <div>GuestListContainer</div>
      </div>
    );
  }
}

const mapState2Props = state => {
  return {
  };
}

export default connect(mapState2Props)(GuestListContainer);
