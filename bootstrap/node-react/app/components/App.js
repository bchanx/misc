import React from 'react';
import { Link, IndexLink } from 'react-router';
import Content from './Content';

class App extends React.Component {
  render() {
    return (
      <div className="container">
        <IndexLink to="/">
          Home
        </IndexLink>
        <Link to="/about" activeClassName="active">about</Link>
        <Content>{this.props.children}</Content>
      </div>
    );
  }
}

export default App;
