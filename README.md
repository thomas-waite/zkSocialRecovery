# zKSocialRecovery

To get started:
1) Clone the repo: `git clone https://github.com/thomas-waite/zkSocialRecovery.git`
2) cd into the directory, `cd zkSocialRecovery`
3) Start ganache in the background, `ganache-cli`
4) Run `yarn install`
5) Run `yarn start`


### Updating logos

- Seach the logos you like at https://icons8.com/
- Save icon with pixel size 96px
- Upload the image into https://imgbb.com/
- Copy image url 
- Replace image url inside ui.json

eg:

```
    {
      "id": "view",
      "title": "View wallet state",
      "description": "View wallet state.",
      "image": {
        "url": "https://i.ibb.co/hLmm9mp/icons8-wallet-96.png"
      },
```

### Adding more UI

(https://solui.dev/docs/specification)
