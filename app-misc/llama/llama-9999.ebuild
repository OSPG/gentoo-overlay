# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit python-any-r1

DESCRIPTION="LLaMA: A C++ library for natural language processing tasks"
HOMEPAGE="https://github.com/ggerganov/llama.cpp"

EGIT_REPO_URI="https://github.com/ggerganov/${PN}.cpp.git"
SRC_URI="
	model_gpt4all? ( https://the-eye.eu/public/AI/models/nomic-ai/gpt4all/gpt4all-lora-quantized.bin )
	tokenizer_llama-7b-hf? ( https://huggingface.co/decapoda-research/llama-7b-hf/resolve/main/tokenizer.model )
"
inherit git-r3


LICENSE="MIT LLaMA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="model_gpt4all tokenizer_llama-7b-hf test"
REQUIRED_USE="
	^^ (
		tokenizer_llama-7b-hf
	)
	^^ (
		model_gpt4all
	)
"

DEPEND="
	dev-lang/perl
	dev-python/numpy
	dev-python/torch
	sci-libs/sentencepiece[python]
"
RDEPEND="${DEPEND}
	dev-libs/openblas
"
BDEPEND="
	dev-util/cmake
	sys-devel/gcc
"

src_prepare() {
	default
	sed -i 's#^\./main#llama#' examples/*.sh || die
	sed -i 's#\./models/#/usr/share/llama/models/#g' examples/*.sh || die
	sed -i 's#\./prompts/#/usr/share/llama/prompts/#g' examples/*.sh || die

	if use tokenizer_llama-7b-hf; then
		mkdir -p "${S}/models"
		cp "${DISTDIR}/tokenizer.model" "${S}/models"
	fi

	if use model_gpt4all; then
		model="gpt4all-7B"
		model_filename="gpt4all-lora-quantized"

		mkdir -p "${S}/models/${model}" || die
		cp "${DISTDIR}/${model_filename}.bin" "${S}/models/${model_filename}.bin" || die
	fi
}

src_configure() {
	mkdir build || die
	cd build || die
	cmake -DCMAKE_BUILD_TYPE=Release .. || die
}

src_compile() {
	cd build || die
	emake

	if use model_gpt4all; then
		model="gpt4all-7B"
		model_filename="gpt4all-lora-quantized"

		pushd "${S}/models/${model}"
		einfo "Converting GPT-4All model"

		# modifies gpt4all-lora-quantized.bin, keeps original in gpt4all-lora-quantized.bin.orig
		python "${S}"/convert-gpt4all-to-ggml.py "${model_filename}.bin" "../tokenizer.model" || die
		mv "./${model_filename}.bin" "./${model_filename}-tokenized.bin"
		mv "./${model_filename}.bin.orig" "./${model_filename}-original.bin"

		# turns -tokenized.bin into -migrated.bin
		python "${S}"/migrate-ggml-2023-03-30-pr613.py "./${model_filename}-tokenized.bin" "./${model_filename}-migrated.bin" || die

		einfo "Done converting GPT-4All model"
		popd
	fi
}

src_install() {
	insinto /usr/lib/llama
	doins build/libllama.a

	exeinto /usr/lib/llama/bin
	doexe build/bin/embedding build/bin/main build/bin/perplexity build/bin/quantize
	dosym /usr/lib/llama/bin/main /usr/bin/llama

	insinto /usr/share/llama
	doins -r examples models prompts spm-headers
	doins convert-ggml-to-pth.py \
		convert-gpt4all-to-ggml.py \
		convert-gptq-to-ggml.py \
		convert-pth-to-ggml.py \
		convert-unversioned-ggml-to-ggml.py \
		migrate-ggml-2023-03-30-pr613.py

	dodoc README.md
}

src_test() {
	emake test
}

