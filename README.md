# HTTProfile

HTTProfile is a side project of TEECOM's research and development group,
[TEECOMlabs](https://labs.teecom.com). We started work on HTTProfile in December
of 2019, heavily inspired by the awesome
[httpstat](https://github.com/reorx/httpstat).

This frontend site was built using a language we love,
[Elm](https://elm-lang.org). It was styled with
[Tailwind](https://tailwindcss.com), complimented by Steve Schoger's beautifully
design icon set, [Zondicons](https://www.zondicons.com), and visually inspired
by Derrick Reimer's [StaticKit](https://statickit.com). The backing API was
written in [Go](https://golang.org), guided by Dave Cheney's implementation of
[httpstat](https://github.com/davecheney/httpstat).

This project adheres to the Contributor Covenant
[code of conduct](./CODE_OF_CONDUCT.md). By participating, you are expected to
uphold this code. Please report unacceptable behavior to
tommy.schaefer@teecom.com.

## Frontend

#### Dependencies

The frontend codebase is written in [Elm](https://elm-lang.org), and depends on
a handful of JavaScript libraries. These libraries are managed by
[yarn](https://yarnpkg.com/en/docs/install#mac-stable), and can be installed
by running the following from the project's root directory:

```
yarn install
```

There are some additional Elm packages you'll want to load too:

```
npx elm install
```

#### Running locally

To run the frontend locally, run the following from the project's root
directory:

```
yarn dev
```

This will start an auto-reloading server for the Elm frontend.

#### Testing

You can run tests by executing the following from the project's root directory:

```
yarn test
```

## Backend

The backend codebase is written in [Go](https://golang.org), and uses Go
modules. To run the backend locally, run the following from the root project
directory:

```
go run httprofile/src/backend
```

This will start up an API server on port `8080`. To run the server on a
different port, run:

```
PORT={custom port} go run httprofle/src/backend
```

instead.

For more information on the API endpoints, check out the
[API documentation](https://httprofile.io/api).

## Contributing

For information on how to contribute to this project, check out the
[contributing guidelines](./CONTRIBUTING.md).

## Deployment

HTTProfile is deployed automatically when code is merged into the `production`
branch. Frontend code is deployed to Netlify, while backend code is deployed
to Heroku.

## Questions?

If you have any questions about HTTProfile, or if any of the documentation is
unclear, please feel free to reach out through a
[new issue](https://github.com/TEECOM/httprofile/issues/new?labels=documentation%20:writing_hand:).

:smiley_cat:
