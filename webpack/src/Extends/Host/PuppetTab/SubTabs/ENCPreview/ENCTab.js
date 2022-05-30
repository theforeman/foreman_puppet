import React from 'react';
import PropTypes from 'prop-types';
import {
  CodeBlock,
  CodeBlockAction,
  CodeBlockCode,
  ClipboardCopyButton,
} from '@patternfly/react-core';

export const ENCTab = ({ encData }) => {
  const [copied, setCopied] = React.useState(false);

  const code = `${encData}`;

  const clipboardCopyFunc = (event, text) => {
    const clipboard = event.currentTarget.parentElement;
    const el = document.createElement('textarea');
    el.value = text.toString();
    clipboard.appendChild(el);
    el.select();
    document.execCommand('copy');
    clipboard.removeChild(el);
  };

  const onClick = (event, text) => {
    clipboardCopyFunc(event, text);
    setCopied(true);
  };

  const actions = (
    <CodeBlockAction>
      <ClipboardCopyButton
        id="copy-button"
        textId="code-content"
        aria-label="Copy to clipboard"
        onClick={e => onClick(e, code)}
        exitDelay={600}
        maxWidth="110px"
        variant="plain"
      >
        {copied ? 'Successfully copied to clipboard!' : 'Copy to clipboard'}
      </ClipboardCopyButton>
    </CodeBlockAction>
  );

  return (
    <CodeBlock actions={actions}>
      <CodeBlockCode id="code-content">{code}</CodeBlockCode>
    </CodeBlock>
  );
};

ENCTab.propTypes = {
  encData: PropTypes.oneOfType([PropTypes.string, PropTypes.object]),
};

ENCTab.defaultProps = {
  encData: undefined,
};

export default ENCTab;
