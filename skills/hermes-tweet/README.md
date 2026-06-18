# Hermes Tweet Skill

Native Hermes Agent X/Twitter workflows for research, reading, monitoring, and controlled posting.

## Install

```bash
hermes plugins install Xquik-dev/hermes-tweet --enable
```

If it is already installed in the Hermes environment, enable it explicitly:

```bash
hermes plugins enable hermes-tweet
```

Set the required read API key:

```bash
export XQUIK_API_KEY="your-api-key"
```

Enable action execution only for approved posting workflows:

```bash
export HERMES_TWEET_ENABLE_ACTIONS=true
```

## Use Cases

- Search and summarize public X/Twitter conversations.
- Read tweet, profile, timeline, and search results from Hermes Agent.
- Monitor community feedback, support signals, launches, or campaigns.
- Execute controlled posting only when the action gate is enabled.

## Source

- https://github.com/Xquik-dev/hermes-tweet
