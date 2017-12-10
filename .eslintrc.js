module.exports = {
    extends: './.eslintrc.google.js',
    parserOptions: {
        "ecmaVersion": 2017,
        "sourceType": "module",
    },
    env: {
        es6: true,
    },
    rules: {
        'arrow-parens': 0,
        'block-spacing': 0,
        'brace-style': 0,
        'camelcase': 0,
        'comma-dangle': 0,
        'comma-style': [2, 'last'],
        'curly': 0,
        'indent': [0, 4],
        'key-spacing': 0,
        'linebreak-style': 0,
        'linebreak-style': 2,
        'max-len': 0,
        'new-cap': 0,
        'no-invalid-this': 0,
        'no-multi-spaces': 0,
        'no-undef': 2,
        'no-unused-vars': 1,
        'object-curly-spacing': 0,
        'padded-blocks': [0, 'never'],
        'quote-props': 0,
        'quotes': 0,
        'require-jsdoc': 0,
        'semi': [1, 'always'],
        'space-before-function-paren': [0, {"anonymous": "never"}],
        'valid-jsdoc': 0,
    },
    globals: {
        // $: true,
        _: true,
        rdfstore: true,
        FormData: true,
        Backbone: true,
        document: true,
        require: true,
        define: true,
        console: true,
        window: true,
        process: true,
        module: true,
        Image: true,
        exports: true,
        parent: true,
        setTimeout: true,
        setInterval: true,
        clearTimeout: true,
        clearInterval: true,
        __dirname: true,
        GM_registerMenuCommand: true,
        __filename: true,
        Buffer: true,
        fetch: true,
    },
}
